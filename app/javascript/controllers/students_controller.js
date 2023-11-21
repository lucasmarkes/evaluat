import { Controller } from "@hotwired/stimulus"
import { get } from '@rails/request.js';

export default class extends Controller {
  static values = { studentId: String }

  connect() {
    var modal = document.getElementById('studentModal');

    if(modal.getAttribute('data-modal-open') == 'true'){
      this.openModal();
    }
  }

  defineTitleModal(title){
    const element = document.getElementById("modal-title")

    element.innerText = title;
  }

  async loadStudent(id){
    await get(`/students/${id}`, {
      headers: {
        'Accept': 'application/json',
      },
    }).then(async (response) => {
      if(response.ok){
        const result = await response.response.json();

        this.setStudentUserIdInField(result.user.id);
        this.setStudentValues(result)
      }else{
        console.log("Modal de error")
      }
    }).catch((error) => {
      console.log("Modal de error")
    })
  }

  setValueField(fieldId, value){
    document.getElementById(fieldId).value = value
  }

  setMethodInStudentForm(path, method){
    const element = document.getElementById("student_form")

    if(method == "POST"){
      element.setAttribute('data-turbo', "false")
    }else{
      element.setAttribute("data-modal-open", "false")
      element.setAttribute('data-turbo', "true")
    }

    element.method = method
    element.action = path
  }

  clearStateField(elementId){
    const element = document.getElementById(elementId)

    element.classList.remove('is-invalid');
    element.classList.remove('is-valid');
  }

  clearStudentValues(){
    this.setValueField("student_user_attributes_first_name", "")
    this.setValueField("student_user_attributes_last_name", "")
    this.setValueField("student_user_attributes_email", "")
    this.setValueField("student_registration_number", "")
    this.setValueField("student_document_number", "")
  }

  clearStateForm(){
    this.clearStateField("student_user_attributes_first_name")
    this.clearStateField("student_user_attributes_last_name")
    this.clearStateField("student_user_attributes_email")
    this.clearStateField("student_registration_number")
    this.clearStateField("student_document_number")
  }

  setStudentValues(student){
    this.setValueField("student_user_attributes_first_name", student.user.first_name)
    this.setValueField("student_user_attributes_last_name", student.user.last_name)
    this.setValueField("student_user_attributes_email", student.user.email)
    this.setValueField("student_registration_number", student.registration_number)
    this.setValueField("student_document_number", student.document_number)
  }

  setStudentUserIdInField(userId){
    document.getElementById("student_user_attributes_id").value = userId
  }

  openModal() {
    document.getElementById("backdrop").style.display = "block"
    document.getElementById("studentModal").style.display = "block"
    document.getElementById("studentModal").classList.add("show")
  }

  newStudent(){
    this.defineTitleModal("Cadastrar Estudante")
    this.clearStateForm()
    this.setMethodInStudentForm("/students", "POST")
    this.setStudentUserIdInField("")
    this.clearStudentValues()
    this.openModal()
  }

  async editStudent() {
    this.defineTitleModal("Editar Estudante")
    this.clearStateForm()
    this.setMethodInStudentForm(`/students/${this.studentIdValue}`, "PUT")
    await this.loadStudent(this.studentIdValue)
    this.openModal()
  }
}

