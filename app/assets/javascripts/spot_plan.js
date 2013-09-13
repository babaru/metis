$(document).ready(function() {

    context.init({
        // fadeSpeed: 100,
        // filter: function($obj) {},
        // above: 'auto',
        preventDoubleContext: false
        // compress: false
    });

    MasterPlanItem = Backbone.Model.extend({
        urlRoot: '/master_plan_items',
        spot_plan_items: null,
        setSpotPlanItems: function(items) {
            this.spot_plan_items = items;
        },
        getSpotPlanItems: function() {
            return this.spot_plan_items;
        }
    });

    MasterPlanItems = Backbone.Collection.extend({
        urlRoot: '/master_plan_items',
        model: MasterPlanItem
    });

    SpotPlanItem = Backbone.Model.extend({
        urlRoot: '/spot_plan_items',
        master_plan_item: null,
        setMasterPlanItem: function(item) {
            this.master_plan_item = item;
        },
        getMasterPlanItem: function() {
            return this.master_plan_item;
        }
    });

    SpotPlanItems = Backbone.Collection.extend({
        model: SpotPlanItem
    });

    MasterPlan = Backbone.Model.extend({urlRoot: '/master_plans'});
    var master_plan = new MasterPlan({id: $('#master-plan-id-value').text()});
    var working_version = $('#working-version-value').text();
    var all_spot_plan_items = new SpotPlanItems();
    master_plan.fetch({
        success: function() {
            var master_plan_items = new MasterPlanItems(null, {url: '/master_plan_items.json?master_plan_id=' + master_plan.get('id') + '&website_id=' + $('#selected-website-id-value').text()});
            master_plan_items.fetch({
                success: function() {

                    _.each(master_plan_items.models, function(model) {
                        var view = new MasterPlanItemView({model: model});
                        view.render();

                        var spot_plan_items = new SpotPlanItems(null, {url: '/spot_plan_items.json?master_plan_item_id=' + model.get('id') + '&wv=' + working_version});
                        spot_plan_items.fetch({
                            success: function() {
                                model.setSpotPlanItems(spot_plan_items);
                                _.each(spot_plan_items.models, function(s_model) {
                                    s_model.setMasterPlanItem(model);
                                    s_model.on('change', function() { model.fetch(); }, model);
                                    var spot_plan_item_view = new SpotPlanItemView({model: s_model});
                                    spot_plan_item_view.render();
                                });

                                $('#master-plan-item' + model.get('id') + ' .empty-spot-plan-item').unbind('click').click(function() {
                                    var new_spot_plan_item = new SpotPlanItem({master_plan_item_id: model.get('id'), count: 1, placed_at: $(this).data('placed-at'), master_plan_item: model});
                                    new_spot_plan_item.save(null, {
                                        success: function() {
                                            new_spot_plan_item.setMasterPlanItem(model);
                                            var spot_plan_item_view = new SpotPlanItemView({model: new_spot_plan_item});
                                            spot_plan_item_view.render();
                                            new_spot_plan_item.on('change', function() { model.fetch(); }, model);
                                            model.getSpotPlanItems().push(new_spot_plan_item);
                                            model.fetch();
                                        }
                                    });
                                });
                            }
                        });
                    });
                }
            });
        }
    });

    MasterPlanItemView = Backbone.View.extend({
        initialize: function() {
            this.model.on('change', this.render, this);
        },
        render: function() {
            console.log('rendering MasterPlanItemView');
            console.log(this.model);
            $('#master-plan-item' + this.model.get('id') + ' .website_name').text(this.model.get('website_name'));
            $('#master-plan-item' + this.model.get('id') + ' .channel_name').text(this.model.get('channel_name'));
            $('#master-plan-item' + this.model.get('id') + ' .spot_name').text(this.model.get('spot_name'));
            $('#master-plan-item' + this.model.get('id') + ' .ideal_count').text(this.model.get('ideal_count'));
            $('#master-plan-item' + this.model.get('id') + ' .reality_count').text(this.model.get('reality_count'));

            if (this.model.get('ideal_count') < this.model.get('reality_count')) {
                $('#master-plan-item' + this.model.get('id') + ' .reality_count').removeClass('warning').addClass('warning');
            } else {
                $('#master-plan-item' + this.model.get('id') + ' .reality_count').removeClass('warning');
            }
            return this;
        }
    });

    SpotPlanItemView = Backbone.View.extend({
        tagName: 'span',
        template: _.template('<%= count %>'),
        initialize: function() {
            this.model.on('change', this.render, this);
        },
        render: function() {
            console.log('rendering SpotPlanItemView');
            console.log(this.model);
            var m = this.model;
            var v = this.$el;
            var that = this;
            this.$el.text(this.template(this.model.attributes));
            this.$el.addClass('spot-plan-item');
            this.$el.attr('id', 'spot_plan_item_' + this.model.get('id'));

            var cell = $('#master-plan-item' + this.model.get('master_plan_item_id') + ' .spot-plan-item-cell' + this.model.get('date_token'));
            cell.html(this.el);

            this.$el.unbind('click').click(function() {
                handleClickSpotPlanItem(m);
            });

            context.attach('#spot_plan_item_' + this.model.get('id'), [
            {
                text: '调整日期',
                action: function(e) {
                    e.preventDefault();
                    $('#spot_plan_item_placed_at').parent().data('datetimepicker').setDate(new Date(m.get('placed_at')));
                    // alert($('.date-picker').data('datetimepicker').setDate(new Date(2013,9,18)));
                    $('#spot-plan-item-modify-placed-at-modal form').attr('action', '/spot_plan_items/' + m.get('id') + '/modify_placed_at.json');
                    $('#spot-plan-item-modify-placed-at-modal').off('ajax:success').on('ajax:success', function(event, data, status, xhr) {
                        console.log(data);
                        $('#spot-plan-item-modify-placed-at-modal').modal('hide');
                        m.fetch();
                        var spi = m.getMasterPlanItem().getSpotPlanItems().findWhere({"id": data["id"]})
                        if (spi == undefined) {
                            spi = new SpotPlanItem({id: data['id']});
                            spi.fetch({
                                success: function() {
                                    spi.setMasterPlanItem(m.getMasterPlanItem());
                                    var spot_plan_item_view = new SpotPlanItemView({model: spi});
                                    spot_plan_item_view.render();
                                    spi.on('change', function() { m.getMasterPlanItem().fetch(); }, m.getMasterPlanItem());
                                    m.getMasterPlanItem().getSpotPlanItems().push(spi);
                                }
                            });
                        } else {
                            console.log(spi);
                            spi.fetch();
                        }
                    })
                    $('#spot-plan-item-modify-placed-at-modal').modal();
                }
            },
            {
                text: '调整数量',
                action: function(e) {
                    e.preventDefault();
                    $('#spot_plan_item_count').val(m.get('count'));
                    $('#spot-plan-item-modify-count-modal form').attr('action', '/spot_plan_items/' + m.get('id') + '.json');
                    $('#spot-plan-item-modify-count-modal').off('ajax:success').on('ajax:success', function(data) {
                        $('#spot-plan-item-modify-count-modal').modal('hide');
                        m.fetch();
                    })
                    $('#spot-plan-item-modify-count-modal').modal();
                }
            },
            {
                text: '清空',
                action: function(e) {
                    e.preventDefault();
                    var master_plan_item_id = m.get('master_plan_item_id');
                    var placed_at = m.get('placed_at');
                    var date_token = m.get('date_token');
                    m.destroy({
                        success: function(model, response) {
                            var master_plan_item = new MasterPlanItem({id: master_plan_item_id});
                            master_plan_item.fetch({
                                success: function() {
                                    var master_plan_item_view = new MasterPlanItemView({model: master_plan_item});
                                    master_plan_item_view.render();
                                    resetSpotPlanItemCell(master_plan_item, placed_at, date_token);
                                }
                            });
                        }
                    });
                }
            }
            ])
            return this;
        }
    })
});

function handleClickSpotPlanItem(spot_plan_item) {
    spot_plan_item.save('count', spot_plan_item.get('count') + 1);
}

function bindEmptySpotPlanItemCellEvent(model, placed_at, date_token) {
    $('#master-plan-item' + model.get('id') + ' .spot-plan-item-cell' + date_token + ' .empty-spot-plan-item').unbind('click').click(function() {
        var new_spot_plan_item = new SpotPlanItem({master_plan_item_id: model.get('id'), count: 1, placed_at: placed_at});
        new_spot_plan_item.save(null, {
            success: function() {
                var spot_plan_item_view = new SpotPlanItemView({model: new_spot_plan_item});
                spot_plan_item_view.render();
                model.fetch();
            }
        });
    });
}

function resetSpotPlanItemCell(model, placed_at, date_token) {
    $('#master-plan-item' + model.get('id') + ' .spot-plan-item-cell' + date_token + ' span').remove();
    $('#master-plan-item' + model.get('id') + ' .spot-plan-item-cell' + date_token).html('<span class="empty-spot-plan-item" data-placed-at="' + placed_at + '"></span>');

    bindEmptySpotPlanItemCellEvent(model, placed_at, date_token);
}
