module Api
  module Aws
    class PlaylistsController < ApplicationController
      def index
        playlists = Playlist.includes(:tracks).all
        formatted_playlists = playlists.map do |playlist|
          {
            id: playlist.id.to_s,
            name: playlist.name,
            kind: playlist.kind,
            artworkUrl100: playlist.artwork_url,
            genres: playlist.tracks.map(&:genres).flatten.uniq,
            url: playlist.url
          }
        end

        response = {
          feed: {
            title: "Top Playlists",
            id: request.original_url,
            author: {
              name: "Your Service Name",
              url: "https://your-service-url.com/"
            },
            links: [
              {
                self: request.original_url
              }
            ],
            copyright: "Copyright © 2024 Your Service Name. All rights reserved.",
            country: "us",
            icon: "https://your-service-url.com/favicon.ico",
            updated: Time.now.strftime("%a, %d %b %Y %H:%M:%S %z"),
            results: formatted_playlists
          }
        }

        render json: response, status: :ok
      end

      def create # Post
        playlist = Playlist.create!(
          name: params[:name],
          kind: params[:kind],
          # artwork_url: params[:artwork_url],
          url: params[:url]
        )

        track_ids = params[:track_ids] || []
        tracks = Track.where(id: track_ids)
        playlist.tracks << tracks

        render json: { message: "Playlist created successfully", playlist: playlist }, status: :created
      end

      def show
        playlist = Playlist.includes(:tracks).find(params[:id])
        render json: playlist, include: [ "tracks" ]
      end

      def fetch_from_yandex_cloud
        YandexCloudService.new.fetch_all_playlists
        render json: { message: "Playlists fetched and created successfully" }
      end
    end
  end
end
