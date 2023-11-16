extends CardAnimation


func on_question_image_changed():
		$QuestionCard/Image.texture = question_image
		$QuestionCard2/Image.texture = question_image
		$QuestionCard3/Image.texture = question_image
		$QuestionCard/Image.scale = CardLib.scale_to_fit(question_image)
		$QuestionCard2/Image.scale = CardLib.scale_to_fit(question_image)
		$QuestionCard3/Image.scale = CardLib.scale_to_fit(question_image)


func on_answer_image_changed():
	$AnswerCard/Image.texture = answer_image
	$AnswerCard/Image.scale = CardLib.scale_to_fit(answer_image)
