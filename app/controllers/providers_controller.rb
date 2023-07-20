class ProvidersController < ApplicationController
  def create
    @provider = Provider.new(provider_params)

    if @provider.save
      render json: @provider, status: :created
    else
      render json: { errors: @provider.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def provider_params
    params.require(:provider).permit(:name, :message_count, :url)
  end
end
