# frozen_string_literal: true

class Api::V1::SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    customer_id = get_customer(params[:stripeToken])
    # Stripe::PaymentMethod.attach(
    #   params[:paymentMethod],
    #   customer: customer_id
    # )
    subscription = Stripe::Subscription.create(
      customer: customer_id,
      plan: 'gold_subscription',
      default_payment_method: params[:paymentMethod]
    )
    test_env?(customer_id, subscription)
    status = Stripe::Invoice.retrieve(subscription.latest_invoice).paid

    if status === true
      current_user.update_attribute(:role, 'subscriber')
      render json: { message: 'Subscription succesfully created!' }, status: :created
    else
      render_stripe_error('Insufficient balance')
    end
  rescue StandardError => e
    render_stripe_error(e.message)
  end

  private

  def test_env?(customer, subscription)
    if Rails.env.test?
      invoice = Stripe::Invoice.create(customer: customer, subscription: subscription.id, paid: true)
      subscription.latest_invoice = invoice.id
    end
  end

  def get_customer(stripe_token)
    customer = Stripe::Customer.list(email: current_user.email).data.first
    customer ||= Stripe::Customer.create(email: current_user.email, source: stripe_token, currency: 'sek')
    customer.id
  end

  def render_stripe_error(error)
    render json: { message: "The subscription was not made. #{error}" }, status: 422
  end
end
