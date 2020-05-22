class Pokemons::TrainersController < ApplicationController
    before_action :get_pokemon
    before_action :get_trainer, only: [:show, :update, :destroy]
  
    def index
      render json: @pokemon.trainers
    end
  
    def create
      @trainer = @pokemon.trainers.build(trainer_params)
      if @trainer.save  
        render json: @trainer
      else
        render json: @trainer.errors
      end
    end
  
    def show
      render json: @trainer
    end
  
    def update
      if @trainer.update_attributes(trainer_params)
        render json: @trainer
      else
        render json: @trainer.errors
      end
    end
  
    def destroy
      @trainer.destroy
      render json: {status: 'Successfully destroyed', data: @trainer}, status: :ok
    end
  
    private
    def get_trainer
      @trainer = Trainer.find_by(id: params[:id])
      return render json: {"error": "this trainer with id #{params[:id]}  doesn't exist"} if @trainer.nil?
      return render json: {"error" => "The trainner doesn't own the pokemon"} if ! @pokemon.trainers.include?(@trainer)
    end
  
    private
    def get_pokemon
      @pokemon = Pokemon.find_by(id: params[:pokemon_id])
      return render json: {"error": "the pokemon with id #{params[:pokemon_id]} doesn't exist"} if @pokemon.nil?
      
    end
  
    def trainer_params
      params.require(:trainer).permit(:name, :gender, :home_region, :team_member_status, :wins, :losses)
    end
  end