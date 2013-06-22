class ChannelsController < ApplicationController
  def index
    @channel_groups = ChannelGroup.includes(:channels)
    @user_channels = current_user.channels
  end

  def create
    Channel.fetch_all
    render :json => :ok
  end

  def update
    UserChannel.create(user_id: current_user.id, channel_id: params[:id])
    render :json => :ok
  end

  def destroy
    UserChannel.where(user_id: current_user.id, channel_id: params[:id]).delete_all
    render :json => :ok
  end
end