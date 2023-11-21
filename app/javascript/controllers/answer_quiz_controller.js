import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const form = document.getElementById("quiz_form");

    form.addEventListener("submit", function(event) {
      event.preventDefault();
      const questionsSize = parseInt(document.getElementById("quiz_questions_quantity").value)
      const radioButtons = document.querySelectorAll('input[type="radio"]:checked')
      const elementsArray = radioButtons ? Array.from(radioButtons) : [];

      if(elementsArray.length < questionsSize){
        alert("Responda todas as questões para finalizar a pesquisa!")
      }else{
        form.submit();
      }
    });
  }
}
