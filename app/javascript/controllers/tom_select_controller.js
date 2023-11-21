import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select";
import { get } from '@rails/request.js'

export default class extends Controller {
  static values = { url: String, searchField: String, labelField: String, secondLabelTitle: String, secondLabelField: String, selectedOptions: String }

  connect() {
    this.initTomSelect();
  }

  initTomSelect() {
    const selectedOptions = JSON.parse(this.selectedOptionsValue);

    var config = {
      valueField: 'id',
      labelField: this.labelFieldValue,
      secondLabelField: this.secondLabelFieldValue,
      secondLabelTitle: this.secondLabelTitleValue,
      options: selectedOptions,
      searchField: [this.searchFieldValue],
      load: (q, callback) => this.search(q, callback),
      render: {
        option: function(item, escape) {
          return `<div style="flex-direction: column;" class="py-2 d-flex">
                <div class="mb-1">
                  <span class="h5">
                    ${ escape(item[this.settings.labelField]) }
                  </span>
                </div>
                ${ this.settings.secondLabelField === '' ?
                    ('') :
                    (`<div class="description">
                      <span class="h6">
                        ${ this.settings.secondLabelTitle }:
                        ${ escape(item[this.settings.secondLabelField]) }
                      </span>
                    </div>`)}
              </div>`;
        },
        no_results:function(data,escape){
          return '<div class="no-results">Nenhum resultado para "'+escape(data.input)+'"</div>';
        },
      },
      i18n: {
        no_results: "Nenhum resultado encontrado",
        remove_item: "Remover item",
        search_placeholder: "Pesquisar...",
      },
    }

    return new TomSelect(`#${this.element.id}`, config);
  }

  async loadData(url, callback){
    await get(url, {
      headers: {
        'Accept': 'application/json',
      },
    }).then(async (response) => {
      if(response.ok){
        const result = await response.response.json();

        callback(result)
      }else{
        callback()
      }
    }).catch((error) => {
      callback()
    })
  }

  search(q, callback) {
    if(q){
      const url = this.urlValue.concat(q)
      this.loadData(url, callback)
    }
  }
}

