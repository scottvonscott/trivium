class Question
    #keep track of question and answers
    #save all the questions

    attr_accessor :text, :category, :difficulty, :correct_answer, :incorrect_answers

    @@all = []

    def intialize
        @@all << self
    end
    
    def self.all
        @@all
    end

end
