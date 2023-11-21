import { Controller } from "@hotwired/stimulus"
import { get } from '@rails/request.js';

export default class extends Controller {
  static values = { schoolClassId: String }

  connect() {
    const modal = document.getElementById('schoolClassModal');

    if(modal.getAttribute('data-modal-open') == 'true'){
      this.openModal();
    }
  }

  defineTitleModal(title){
    const element = document.getElementById("modal-title")

    element.innerText = title;
  }

  async loadSchoolClass(id){
    await get(`/school_classes/${id}`, {
      headers: {
        'Accept': 'application/json',
      },
    }).then(async (response) => {
      if(response.ok){
        const result = await response.response.json();

        this.setSchoolClassValues(result)
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

  setMethodInSchoolClassForm(path, method){
    const element = document.getElementById("school_class_form")

    if(method == "POST"){
      element.setAttribute('data-turbo', "false")
    }else{
      element.setAttribute("data-modal-open", "false")
      element.setAttribute('data-turbo', "true")
    }

    element.method = method
    element.action = path
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

  clearStateForm(){
    this.clearStateField("school_class_discipline_name")
    this.clearStateField("school_class_teacher_name")
    this.clearStateField("school_class_shift")
    this.clearStateField("school_class_course")
    this.clearStateField("list-students", document.querySelectorAll(".select.multi")[0])
  }

  clearSchoolClassValues(){
    this.setValueField("school_class_discipline_name", "")
    this.setValueField("school_class_teacher_name", "")
    this.setValueField("school_class_shift", "")
    this.setValueField("school_class_course", "")
    this.setStudentsOptions([])
  }

  setStudentsOptions(students){
    const element = document.getElementById("list-students")
    const control = element.tomselect
    let studentIds = []

    control.clearOptions()

    students.forEach(student => {
      control.addOption(student)

      studentIds.push(student.id)
    });

    control.setValue(studentIds)
  }

  setSchoolClassValues(schoolClass){
    this.setValueField("school_class_discipline_name", schoolClass.discipline_name)
    this.setValueField("school_class_teacher_name", schoolClass.teacher_name)
    this.setValueField("school_class_shift", schoolClass.shift)
    this.setValueField("school_class_course", schoolClass.course)
    this.setStudentsOptions(schoolClass.students_option_object_list)
  }

  openModal() {
    document.getElementById("backdrop").style.display = "block"
    document.getElementById("schoolClassModal").style.display = "block"
    document.getElementById("schoolClassModal").classList.add("show")
  }

  newSchoolClass(){
    this.defineTitleModal("Cadastrar Turma")
    this.clearStateForm()
    this.setMethodInSchoolClassForm("/school_classes", "POST")
    this.clearSchoolClassValues()
    this.openModal()
  }

  async editSchoolClass() {
    this.defineTitleModal("Editar Turma")
    this.clearStateForm()
    this.setMethodInSchoolClassForm(`/school_classes/${this.schoolClassIdValue}`, "PUT")
    await this.loadSchoolClass(this.schoolClassIdValue)
    this.openModal()
  }
}

