$(document).ready(function() {
    context.init({ preventDoubleContext: false });

    MasterPlan = Backbone.Model.extend({urlRoot: '/master_plans'});

    MasterPlanSummaryView = Backbone.View.extend({
        initialize: function() {
            this.model.on('change', this.render, this);
        },
        render: function() {
            // $('#master-plan-summary .project-budget').text(
            //     accounting.formatMoney(
            //         this.model.get('budget'),
            //         {
            //             symbol: '￥',
            //             format: '%s %v',
            //             precision: 0
            //         })
            //     );
            // $('#master-plan-summary .medium-net-cost').text(
            //     accounting.formatMoney(
            //         this.model.get('medium_net_cost'),
            //         {
            //             symbol: '￥',
            //             format: '%s %v',
            //             precision: 0
            //         })
            //     );
            // $('#master-plan-summary .company-net-cost').text(
            //     accounting.formatMoney(
            //         this.model.get('company_net_cost'),
            //         {
            //             symbol: '￥',
            //             format: '%s %v',
            //             precision: 0
            //         })
            //     );
            // $('#master-plan-summary .profit').text(
            //     accounting.formatMoney(
            //         this.model.get('profit'),
            //         {
            //             symbol: '￥',
            //             format: '%s %v',
            //             precision: 0
            //         })
            //     );
            // $('#master-plan-summary .reality_bonus_ratio').text(this.model.get('reality_bonus_ratios')[$('#selected-medium-id-value').text()]);
            // $('#master-plan-summary .medium_bonus_ratio').text(this.model.get('medium_bonus_ratios')[$('#selected-medium-id-value').text()]);
            // $('#master-plan-summary .company_bonus_ratio').text(this.model.get('company_bonus_ratios')[$('#selected-medium-id-value').text()]);
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
