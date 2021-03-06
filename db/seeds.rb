require 'csv'

File.open("db/pokemon-lite-api.csv", "r") do |file|
  lines =  CSV.parse(file.read, headers: true, header_converters: :symbol)

  trainers = lines
  .map do |line| 
    {
      name: line[:t_name],
      gender:line[:t_gender],
      home_region: line[:t_region],
      team_member_status: line[:t_team_member] == "true",
      wins: line[:wins],
      losses: line[:losses]
    }
  end
  .uniq
  .map {|trainer| Trainer.find_or_create_by(trainer)}

  pokemons = lines
  .map do |line| 
    {
      name: line[:name],
      base_experience: line[:base_exp].to_i,
      main_type: line[:main_type],
      main_ability: line[:main_ability]
    }
  end
  .uniq
  .map {|pokemon| Pokemon.find_or_create_by(pokemon)}

  trainers.each do |trainer|
    captures = trainer.captures
    pokemon_for_trainer = lines
    .select {|line| line[:t_name] == trainer.name }
    .map{ |pokemon_line| pokemons.find{|pokemon| pokemon.name == pokemon_line[:name] }}
    .map do |pokemon| 
      captures
      .build(pokemon: pokemon, experience: pokemon.base_experience)
      .save
    end

  end
end