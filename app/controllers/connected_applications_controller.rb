class ConnectedApplicationsController < ApplicationController
  def destroy
    current_user.disable_application!(params[:id])
    redirect_to connected_applications_path
  end

  private

  def connected_applications
    current_user.connected_applications
  end
  helper_method :connected_applications
end
