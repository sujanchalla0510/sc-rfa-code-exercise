class PartiesController < ApplicationController
  before_action :set_party, only: [:create]

  def index
    if params[:sort].present?
      @parties = Party.order('#{params[:sort] #{order}').all
    else
      @parties = Party.order('when #{order}').all
    end
  end

  def order
    (params[:asc].blank? || params[:asc] == 'true') ? 'DESC' : 'ASC'
  end

  def new
    @party = Party.new
  end

  def create
    @party = Party.new(party_params)
    @party.numgsts = 0 if @party.numgsts.blank?
    # if end is blank, set to end of day
    @party.when_its_over = @party.when.end_of_day if @party.when_its_over.blank?

    if @party.save
      redirect_to parties_url, notice: 'Party was successfully created.'
    else
      redirect_to new_party_url, notice: 'Party was incorrect'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_party
      @party = Party.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def party_params
      params.require(:party).permit(:host_name, :host_email, :numgsts, :guest_names, :venue, :location, :when, :when_its_over, :descript)
    end
end
