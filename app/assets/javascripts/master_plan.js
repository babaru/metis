$(document).ready(function() {
    context.init({ preventDoubleContext: false });

    MasterPlan = Backbone.Model.extend({urlRoot: '/master_plans'});

    MasterPlanSummaryView = Backbone.View.extend({
        initialize: function() {
            this.model.on('change', this.render, this);
        },
        render: function() {
            $('#master-plan-summary .budget').text(this.model.get('budget'));
            $('#master-plan-summary .contract_price').text(this.model.get('website_contract_prices')[$('#selected-website-id-value').text()] + ' (' + this.model.get('contract_price') + ')');
            $('#master-plan-summary .profit').text(this.model.get('website_profits')[$('#selected-website-id-value').text()] + ' (' + this.model.get('profit') + ')');
            return this;
        }
    });

    update_master_plan_summary();
});

function update_master_plan_summary() {
    var master_plan = new MasterPlan({id: $('#master-plan-id-value').text()});
    master_plan.fetch({
        success: function() {
            var master_plan_summary_view = new MasterPlanSummaryView({model: master_plan});
            master_plan_summary_view.render();
        }
    });
}
