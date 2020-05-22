class Trainers::PokemonsController < ApplicationController
  before_action :get_trainer
  before_action :get_pokemon, only: [:show, :update, :destroy]

  def index
    render json: @trainer.pokemons
  end

  def create
    @pokemon = @trainer.pokemons.build(pokemon_params())
    if @pokemon.save  
      @trainer.pokemons << @pokemon
      render json: @pokemon
    else
      render json: @pokemon.errors
    end
  end

  def show
    render json: @pokemon
  end

  def update
    if @pokemon.update_attributes(pokemon_params)
      render json: @pokemon
    else
      render json: @pokemon.errors
    end
  end

  def destroy
    @pokemon.destroy
    render json: {status: 'Successfully destroyed', data: @pokemon}, status: :ok
  end

  private
  def get_trainer
    @trainer = Trainer.find_by(id: params[:trainer_id])
    return render json: {"error": "this trainer with id #{params[:trainer_id]}  doesn't exist"} if @trainer.nil?
  end

  private
  def get_pokemon
    @pokemon = Pokemon.find_by(id: params[:id])
    return render json: {"error": "the pokemon with id #{params[:id]} doesn't exist"} if @pokemon.nil?
    return render json: {"error" => "The trainner doesn't own the pokemon"} if ! @pokemon.trainers.include?(@trainer)
  end

  def pokemon_params
    params.require(:pokemon).permit(:name, :base_experience, :main_type, :main_ability)
  end
end