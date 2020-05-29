class API
    #make calls to API


    def self.get_trivia(difficulty)
        if difficulty == "easy"
            url = "https://opentdb.com/api.php?amount=10&difficulty=easy&type=multiple&encode=base64"
        elsif difficulty == "medium"
            url = "https://opentdb.com/api.php?amount=10&difficulty=medium&type=multiple"
        elsif difficulty == "hard"
            url = "https://opentdb.com/api.php?amount=10&difficulty=hard&type=multiple"
        end
        uri = URI(url)
        response = Net::HTTP.get(uri)
        hash = JSON.parse(response)
        array_of_questions = hash["results"]

        array_of_questions.collect do |question_hash|
            decoded_array = []
            question_hash["incorrect_answers"].each do |answer|
                decoded_array << Base64.decode64(answer)
            end
            Question.new(text: Base64.decode64(question_hash["question"]), category: Base64.decode64(question_hash["category"]), difficulty: Base64.decode64(question_hash["difficulty"]), correct_answer: Base64.decode64(question_hash["correct_answer"]), incorrect_answers: decoded_array)
        end

        #initialize new question
        #assign attributes
        
        



    end
    
end

# The Open Trivia DB may contain questions which contain Unicode or Special Characters. For this reason, the API returns results in a encoded format. You can specify the desired encoding format using the examples below. If the encode type is not present in the URL, it will follow the default encoding.

# API Call with Encode Type (urlLegacy, url3986, base64):
# https://opentdb.com/api.php?amount=10&encode=url3986


