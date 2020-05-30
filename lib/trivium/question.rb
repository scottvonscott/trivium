class Question

    attr_accessor :text, :category, :difficulty, :correct_answer, :incorrect_answers

    @@all = []

    def initialize (text:, category:, difficulty:, correct_answer:, incorrect_answers:)
        @text = text
        @category = category
        @difficulty = difficulty
        @correct_answer = correct_answer
        @incorrect_answers = incorrect_answers
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

    def self.destroy_all
        self.all.clear
    end

end
