module Api
  module Aws
    class TracksController < ApplicationController
      def index
        @tracks = Track.all
        render json: @tracks
      end

      def sync
        yandex_service = YandexCloudService.new
        yandex_service.fetch_all_tracks
        render json: { message: "Tracks synced successfully" }
      end
    end
  end
end
