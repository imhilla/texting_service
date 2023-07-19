class ApplicationController < ActionController::API
  def health_check
    render json: { status: "ok", version: "1.0" }
  end
end
