class AddVideoProcessingToVideoUpload < ActiveRecord::Migration
  def change
    add_column :video_uploads, :video_processing, :boolean, after: :video_updated_at
  end
end