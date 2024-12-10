module Api
  module Aws
    class TracksController < ApplicationController
      def index
        @tracks = Track.all
        render json: tracks.map { |track| format_track(track) }, status: :ok
      end

      def sync
        yandex_service = YandexCloudService.new
        yandex_service.fetch_all_tracks
        render json: { message: "Tracks synced successfully" }
      end


      private

      def format_track(track)
        {
          artistName: track.artist_name,
          id: track.id,
          name: track.name,
          releaseDate: track.release_date,
          kind: track.kind,
          artistId: track.artist_id,
          artistUrl: track.artist_url,
          contentAdvisoryRating: track.content_advisory_rating,
          artworkUrl100: track.artwork_url,
          genres: track.genres,
          url: track.cloud_url
        }
      end
    end
  end
end
