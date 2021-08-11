module Api
  module V1
    class SnapshotsController < ApiController
      
      def presigned_url
        # candidate = @drives_candidate.candidate
        filename = "#{params[:token]}/#{DateTime.current}"
        presigned_url = request_presigned_url(filename)

        render_success(data: { url: presigned_url }, message: I18n.t('success.message'))
      end

      def create
        snapshot = Snapshot.new(image_url: params[:presigned_url].split('?').first, token: params[:token])

        if snapshot.save
          render_success(data: { snapshot: serialize_resource(snapshot, SnapshotSerializer) },
                         message: I18n.t('create.success', model_name: Snapshot))
        else
          render_error(message: snapshot.errors.messages, status: 400)
        end
      end

      def index
        snapshots = Snapshot.where(token: params[:token])

        render_success(data: { snapshots: serialize_resource(snapshots, SnapshotSerializer) },
                       message: I18n.t('index.success', model_name: Snapshot))
      end
      
      def request_presigned_url(filename)
        byebug
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
