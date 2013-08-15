$(document).ready(function() {

    context.init({
        // fadeSpeed: 100,
        // filter: function($obj) {},
        // above: 'auto',
        preventDoubleContext: false
        // compress: false
    });

    MasterPlanItem = Backbone.Model.extend({
        urlRoot: '/master_plan_items'
    });

    MasterPlanItems = Backbone.Collection.extend({
        urlRoot: '/master_plan_items',
        model: MasterPlanItem
    });

    MasterPlan = Backbone.Model.extend({urlRoot: '/master_plans'});
    var master_plan = new MasterPlan({id: 2});
    master_plan.fetch({
        success: function() {
            var master_plan_items = new MasterPlanItems(null, {url: '/master_plan_items.json?master_plan_id=' + master_plan.get('id')});
            master_plan_items.fetch({
                success: function() {
                    // console.log(master_plan_items.length);
                    _.each(master_plan_items.models, function(model) {
                        var view = new MasterPlanItemView({model: model});
                        view.render();
                        // _(31).times(function(n) {
                            // view.$el.append(emptySpotPlanItemView(model, n + 1));
                        // });
                        var spot_plan_items = new SpotPlanItems(null, {url: '/spot_plan_items.json?master_plan_item_id=' + model.get('id')});
                        var previous_day_index = 0;
                        spot_plan_items.fetch({
                            success: function() {
                                _.each(spot_plan_items.models, function(s_model) {
                                    var current_day_index = parseInt(s_model.get('day_index')) + 5;
                                    var s_view = new SpotPlanItemView({model: s_model});
                                    s_view.render();
                                    view.$el.find('td:nth-child(' + current_day_index + ')').html(s_view.el);
                                });
                            }
                        });
                        $('#spot-plan-table').append(view.el);
                    });
                }
            });
        }
    });

    SpotPlanItem = Backbone.Model.extend({
        urlRoot: '/spot_plan_items'
    });

    SpotPlanItems = Backbone.Collection.extend({
        model: SpotPlanItem
    });

    MasterPlanItemView = Backbone.View.extend({
        tagName: 'tr',
        template: _.template('<td><%= website_name %></td><td><%= channel_name %></td><td><strong><%= spot_name %></strong></td><td><span><%= ideal_count %></span></td><td><span><%= reality_count %></span></td>'),
        initialize: function() {
            // this.model.on('change', this.render, this);
            // this.collection.each()
        },
        render: function() {
            // console.log("render master_plan_item");
            $('#master_plan_item_' + this.model.get('id') + ' .website_name').text(this.model.get('website_name'));
            $('#master_plan_item_' + this.model.get('id') + ' .channel_name').text(this.model.get('channel_name'));
            $('#master_plan_item_' + this.model.get('id') + ' .spot_name').text(this.model.get('spot_name'));
            $('#master_plan_item_' + this.model.get('id') + ' .ideal_count').text(this.model.get('ideal_count'));
            $('#master_plan_item_' + this.model.get('id') + ' .reality_count').text(this.model.get('reality_count'));
            return this;
        }
    });

    SpotPlanItemView = Backbone.View.extend({
        tagName: 'span',
        template: _.template('<%= count %>'),
        render: function() {
            this.$el.text(this.template(this.model.attributes));
            this.$el.addClass('spot-plan-item');
            this.$el.attr('id', 'spot_plan_item_' + this.model.get('id'));
            var m = this.model;
            var v = this.$el;
            context.attach('#spot_plan_item_' + this.model.get('id'), [
            {
                text: '调整数量',
                action: function(e) {
                    e.preventDefault();
                    alert(m.get('id'));
                }
            },
            {
                text: '清空',
                action: function(e) {
                    e.preventDefault();
                    m.destroy({
                        success: function(model, response) {
                            v.replaceWith('<td class="spot-plan-item empty"></td>');
                        }
                    });
                }
            }
            ])
            return this;
        },

        events: {
            'click': 'add_count',
            'contextmenu': 'open_contextmenu'
        },

        add_count: function() {
            var self = this;
            this.model.save('count', this.model.get('count') + 1, {
                success: function(m, r, opt) {
                    self.render();
                }
            });
        }
    })

});

function emptySpotPlanItemView(master_plan_item, month_day) {
    return $('<td class="spot-plan-item empty"></td>').click(function() {
        var self = this;
        new_spot_plan_item = new SpotPlanItem({master_plan_item_id: master_plan_item.get('id'), count: 1, placed_at: '2013-9-' + month_day});
        new_spot_plan_item.save(null, {
            success: function() {
                var s_view = new SpotPlanItemView({model: new_spot_plan_item});
                s_view.render();
                $(self).replaceWith(s_view.el);
                master_plan_item.fetch({
                    success: function() {
                        // master_plan_item.view.render();
                    }
                });
            }
        });
    });
}
