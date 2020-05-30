class Player

    attr_accessor :name

    @@all = []
    
    def initialize(name)
        @name = name
        @scores = []
        @games = []
        save
    end

    def save
        unless @@all.include?(self)
            @@all << self
        end
    end

    def self.all
        @@all
    end

    def add_game(game)
        game.player = self unless game.player
        unless @games.include?(game)
            @games << game
        end
    end

    def self.create(player)
        player = Player.new(player)
        player.save
        player
    end

    def self.find_by_name(name)
        self.all.detect {|p| p.name == name}
    end

    def self.find_or_create_by_name(name)
        if self.find_by_name(name) != nil
            self.find_by_name (name)
        else
            self.create(name)
        end
    end


    def games
        @games
    end

    def scores
        @scores
    end

    def self.all
        @@all
    end

end




