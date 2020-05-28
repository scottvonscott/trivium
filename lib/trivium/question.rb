class Question
    #keep track of question and answers
    #save all the questions

    attr_accessor :text, :category, :difficulty, :correct_answer, :incorrect_answers

    @@all = []

    def initialize (text:, category:, difficulty:, correct_answer:, incorrect_answers:)
        @text = text
        @category = category
        @difficulty = difficulty
        @correct_answer = correct_answer
        @incorrect_answers = incorrect_answers
        @@all << self
    end
    
    def self.all
        @@all
    end

    def self.destroy_all
        self.all.clear
    end

end
