class ProvidersController < ApplicationController
  before_action :set_provider, only: [:update]

  def index
    @providers = Provider.all
    render json: @providers, status: :ok
  end

  def create
    @provider = Provider.new(provider_params)

    if @provider.save
      render json: @provider, status: :created
    else
      render json: { errors: @provider.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @provider.update(provider_params)
      render json: @provider, status: :ok
    else
      render json: { errors: @provider.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_provider
    @provider = Provider.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Provider not found" }, status: :not_found
  end

  def provider_params
    params.require(:provider).permit(:name, :message_count, :url)
  end
end
