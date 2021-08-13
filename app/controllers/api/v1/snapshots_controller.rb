# frozen_string_literal: true

module Api
  module V1
    class SnapshotsController < ApiController
      def presigned_url
        filename = "#{params[:first_name]}#{params[:last_name]}/#{params[:token]}/#{DateTime.current}"
        presigned_url = request_presigned_url(filename)
        render_success(data: { url: presigned_url }, message: I18n.t('success.message'))
      end

      def create
        render_success(data: nil, message: I18n.t('missing_parameter.message'), status: 200) and return unless params[:token]

        snapshot = Snapshot.new(image_url: params[:presigned_url].split('?').first, token: params[:token])
        snapshot_create(snapshot)
      end

      def snapshot_create(snapshot)
        if snapshot.save
          render_success(data: { snapshot: serialize_resource(snapshot, SnapshotSerializer) },
                         message: I18n.t('create.success', model_name: Snapshot))
        else
          render_error(message: snapshot.errors.messages, status: 400)
        end
      end

      def index
        render_success(data: nil, message: I18n.t('missing_parameter.message'), status: 200) and return unless params[:token]

        snapshots = Snapshot.where(token: params[:token])
        render_success(data: { snapshots: serialize_resource(snapshots, SnapshotSerializer) },
                       message: I18n.t('index.success', model_name: Snapshot))
      end

      def request_presigned_url(filename)
        signer = Aws::S3::Presigner.new
        signer.presigned_url(:put_object,
                             bucket: ENV['S3_BUCKET'],
                             key: filename,
                             acl: 'public-read',
                             content_type: 'image/jpeg')
      end
    end
  end
end
