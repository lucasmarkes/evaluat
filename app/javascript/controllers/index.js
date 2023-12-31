// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"
import TomSelectController from "./tom_select_controller"
import StudentsController from "./students_controller"
import CpfInputMaskController from "./cpf_input_mask_controller"
import SchoolClassesController from "./school_classes_controller"
import QuizzesController from "./quizzes_controller"
import AnswerQuizController from "./answer_quiz_controller"
import DashboardController from "./dashboard_controller"

application.register("tom-select", TomSelectController)
application.register("students", StudentsController)
application.register("school-classes", SchoolClassesController)
application.register("cpf-input-mask", CpfInputMaskController)
application.register("quizzes", QuizzesController)
application.register("answer-quiz", AnswerQuizController)
application.register("dashboard", DashboardController)
