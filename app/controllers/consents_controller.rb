# frozen_string_literal: true

class ConsentsController < ApplicationController
  before_action :set_consent, only: %i[show update destroy]

  # GET /consents
  def index
    @consents = Consent.all

    render json: @consents
  end

  # GET /consents/1
  def show
    render json: @consent
  end

  # POST /consents
  def create
    @consent = Consent.new(consent_params)

    if @consent.save
      render json: @consent, status: :created, location: @consent
    else
      render json: @consent.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /consents/1
  def update
    if @consent.update(consent_params)
      render json: @consent
    else
      render json: @consent.errors, status: :unprocessable_entity
    end
  end

  # DELETE /consents/1
  def destroy
    @consent.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_consent
    @consent = Consent.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def consent_params
    params.fetch(:consent, {})
  end
end
