class Category

    attr_accessor :name, :id

    @@all = []

    def initialize (id:, name:)
        @name = name
        @id = id
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


end