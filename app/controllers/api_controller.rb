# frozen_string_literal: true

class ApiController < ActionController::API
  # include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from ActiveRecord::RecordNotFound, with: :error_render_method
  rescue_from ActiveRecord::RecordInvalid, with: :error_render_method
  # rescue_from ActiveRecord::NotNullViolation, with: :render_missing_error

  # rescue_from CanCan::AccessDenied do |_exception|
  #   render json: { message: I18n.t('user.unauthorized') }, status: 403
  # end

  def render_success(data: nil, message: nil, status: 200)
    render json: { data: data, message: message }, status: status
  end

  def render_error(message: nil, status: 400)
    render json: message, status: status
  end

  def error_render_method
    render_error(message: I18n.t('not_found.message'), status: 404)
  end

  def serialize_resource(resources, serializer, root = nil, extra = {})
    opts = { each_serializer: serializer, root: root }.merge(extra)
    ActiveModelSerializers::SerializableResource.new(resources, opts) if resources
  end

  def render_missing_error
    render json: { data: {}, message: I18n.t('missing_parameter.message') }, status: 200
  end
end
