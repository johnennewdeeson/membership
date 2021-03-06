class GroupsController < ApplicationController
  before_action :authenticate_admin, only: [:new, :create]

  def index
    @groups = current_user.viewable_groups
  end
  def show
    @group = current_user.viewable_groups.find(params[:id])
  end
  def new
    @group = Group.new(filter: params[:filter])
  end
  def create
    @group = Group.new(group_params)
    if @group.save!
      @group.update_memberships
      redirect_to group_path(@group)
    else
      render :new
    end
  end
  def edit
    @group = current_user.viewable_groups.find(params[:id])
  end
  def update
    @group = current_user.viewable_groups.find(params[:id])
    if @group.update_attributes(group_params)
      redirect_to group_path(@group)
    else
      render :edit
    end
  end

  private

  def group_params
    permitted_attrs = [:name, :description, :why_receiving, :automatic_update]
    if current_user.admin?
      permitted_attrs << :filter
    end
    params.require(:group).permit(permitted_attrs)
  end
end
