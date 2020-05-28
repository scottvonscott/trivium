class API
    #make calls to API


    def self.get_trivia
        url = "https://opentdb.com/api.php?amount=10&difficulty=medium&type=multiple"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        hash = JSON.parse(response)
        array_of_questions = hash["results"]

        array_of_questions.each do |question_hash|
            question_instance = Question.new
            question_instance.text = question_hash["question"]
            question_instance.category = question_hash["category"]
            question_instance.difficulty = question_hash["difficulty"]
            question_instance.correct_answer = question_hash["correct_answer"]
            question_instance.incorrect_answers = question_hash["incorrect_answers"]

        #initialize new drink
        #assign attributes
        binding.pry
        end
    



    end
    
end


