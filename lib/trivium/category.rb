class Category
    #keeps track of categories

    attr_accessor :name, :id, :quesiton

    @@all = []

    def initialize (id:, name:)
        @name = name
        @id = id
        @@all << self
    end

    def self.all
        @@all
    end


end