module Api
  module Aws
    class PlaylistsController < ApplicationController
      def index
        playlists = Playlist.includes(:tracks).all
        render json: playlists, include: [ "tracks" ]
      end

      def create # Post
        playlist = Playlist.create!(
          name: params[:name],
          kind: params[:kind],
          artwork_url: params[:artwork_url],
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
    end
  end
end
