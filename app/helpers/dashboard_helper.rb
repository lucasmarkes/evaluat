module DashboardHelper
  include Rails.application.routes.url_helpers

  def build_menu_link(link)
    if link[:admin_only]
      return unless current_user.admin?
    end

    content_tag(:li, link[:name], class: "nav-item") do
      link_to link[:name], link[:path], class: "nav-link #{params[:controller] == link[:id] ? "active" : nil}"
    end
  end

  def menu_links
    [
      {id: 'dashboard', name: 'Home', path: root_path, admin_only: false},
      {id: 'students', name: 'Alunos', path: students_path, admin_only: true},
      {id: 'school_classes', name: 'Turmas', path: school_classes_path, admin_only: true},
      {id: 'quizzes', name: 'Pesquisas', path: quizzes_path, admin_only: true}
    ]
  end
end
