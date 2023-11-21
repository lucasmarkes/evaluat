import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("input", this.formatCpf)
  }

  disconnect() {
    this.element.removeEventListener("input", this.formatCpf)
  }

  formatCpf(event) {
    const input = event.target
    let value = input.value.replace(/\D/g, "")

    if (value.length > 11) {
      value = value.slice(0, 11)
    }

    if (value.length > 9) {
      input.value = value.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, "$1.$2.$3-$4")
    } else if (value.length > 6) {
      input.value = value.replace(/(\d{3})(\d{3})(\d{3})/, "$1.$2.$3-")
    } else if (value.length > 3) {
      input.value = value.replace(/(\d{3})(\d{3})/, "$1.$2.")
    } else {
      input.value = value
    }
  }
}
