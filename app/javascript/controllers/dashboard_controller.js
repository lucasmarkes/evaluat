import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.addMenuToogleEvent();
  }

  addMenuToogleEvent(){
    const menuToggle = document.getElementById("menuToggle");
    const navbarNav = document.querySelector(".navbar-collapse");

    menuToggle.addEventListener("click", function(){
      if(navbarNav.classList.contains("show")){
        navbarNav.classList.remove("show");
      }else{
        navbarNav.classList.add("show");
      }
    });
  }
}
