import { Controller } from "@hotwired/stimulus"
import { get } from '@rails/request.js';

export default class extends Controller {
  static values = { quizId: String }

  connect() {
    this.initializeChart();
    const modal = document.getElementById('quizModal');

    if(modal.getAttribute('data-modal-open') == 'true'){
      this.openModal();
    }
  }

  initializeChart() {
    document.addEventListener('DOMContentLoaded', function () {
      const ctx = document.getElementById('resultMetricsBarChart')
      if(!Chart.getChart(ctx)){
        ctx.getContext('2d');

        new Chart(ctx, {
          type: 'bar',
          data: {
            labels: [],
            datasets: [{
              label: 'Média das Avaliações',
              data: [],
              backgroundColor: 'rgba(54, 162, 235, 0.2)',
              borderColor: 'rgba(54, 162, 235, 1)',
              borderWidth: 1
            }]
          },
          options: {
            indexAxis: 'y',
            scales: {
              x: {
                beginAtZero: true,
                ticks: {
                  callback: function(value) {
                    if (value % 1 === 0) {
                      return value;
                    }
                  },
                  stepSize: 1
                }
              }
            }
          }
        });
      }
    });
  }

  defineTitleModal(title){
    const element = document.getElementById("modal-title")

    element.innerText = title;
  }

  async loadQuiz(id){
    await get(`/quizzes/${id}`, {
      headers: {
        'Accept': 'application/json',
      },
    }).then(async (response) => {
      if(response.ok){
        const result = await response.response.json();

        this.setQuizValues(result);
      }else{
        console.log("Modal de error")
      }
    }).catch((error) => {
      console.log("Modal de error")
    })
  }

  setValueField(fieldId, value){
    const element = document.getElementById(fieldId)

    element.value = value
  }

  clearStateField(elementId, element=undefined){
    if(element == undefined){
      element = document.getElementById(elementId)
    }else{
      document.querySelectorAll(".invalid-feedback").forEach((element) => {
        element.style.display = "none"
      })
    }

    element.classList.remove('is-invalid');
    element.classList.remove('is-valid');
  }

  changeFields(enable) {
    if(enable){
      document.getElementById("list-school-class").tomselect.enable()
    }else{
      document.getElementById("list-school-class").tomselect.disable()
    }

    ["quiz_name", "btn_submit_quiz_form"].forEach((id) => {
      document.getElementById(id).disabled = !enable
    })
  }

  clearStateForm(){
    this.clearStateField("quiz_name")
    this.clearStateField("list-school-class", document.querySelectorAll(".select.single")[0])
  }

  clearSchoolClassValues(){
    this.setValueField("quiz_name", "")
    this.setSchoolClassOption(null)
    this.setResultMetrics(null)
  }

  setSchoolClassOption(schoolClass = null){
    const element = document.getElementById("list-school-class")
    const control = element.tomselect
    if(!schoolClass){
      control.clearOptions()
      control.setValue(0)

      return;
    }

    control.clearOptions()
    control.addOption(schoolClass)
    control.setValue(schoolClass.id)
  }

  setResultMetrics(result_metrics){
    const element = document.getElementById("result_metrics")
    if(result_metrics){
      element.style.display = "block"
      let questionLabels = [];
      let results = [];
      result_metrics.forEach((metric) => {
        questionLabels.push(metric.question_text)
        results.push(metric.value)
      })
      const chartElement = document.getElementById("resultMetricsBarChart");
      const chartInstance = Chart.getChart(chartElement);

      chartInstance.data.labels = questionLabels;

      chartInstance.data.datasets[0].data = results;

      chartInstance.update();
    }else{
      element.style.display = "none"
    }
  }

  setQuizValues(quiz){
    this.setValueField("quiz_name", quiz.name)
    this.setSchoolClassOption(quiz.school_class)
    this.setResultMetrics(quiz.result_metrics)
  }

  openModal() {
    document.getElementById("backdrop").style.display = "block"
    document.getElementById("quizModal").style.display = "block"
    document.getElementById("quizModal").classList.add("show")
  }

  newQuiz(){
    this.defineTitleModal("Cadastrar Quiz")
    this.clearStateForm()
    this.clearSchoolClassValues()
    this.changeFields(true)
    this.openModal()
  }

  async showQuiz() {
    this.defineTitleModal("Quiz")
    this.clearStateForm()
    await this.loadQuiz(this.quizIdValue)
    this.changeFields(false)
    this.openModal()
  }
}

