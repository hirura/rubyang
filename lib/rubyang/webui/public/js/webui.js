// Global Variables
id_index = -1;
list_schema_tree = {};

function next_id(){
	id_index = id_index + 1;
	var next_id = 'node' + id_index;
	return next_id;
}

function make_form(trees, parent_id){
	for(var i=0; i<trees.length; i++){
		var stmt = Object.keys(trees[i])[0];
		var tree = trees[i][stmt];
		if(stmt == "root"){
			var children = tree["children"];
			make_form(children, parent_id);
		}else if(stmt == "container"){
			var child_schema_path = parent_id + '/' + tree["name"];
			var child_id = next_id();
			addcontainer(parent_id, child_id, child_schema_path, tree["name"], tree["description"], '');
			var children = tree["children"];
			make_form(children, child_id);
		}else if(stmt == "list"){
			var child_schema_path = parent_id + '/' + tree["name"];
			var child_id = next_id();
			addlist(parent_id, child_id, child_schema_path, tree["name"], tree["description"], '');
			var children = tree["children"];
			list_schema_tree[child_id] = children;
		}else if(stmt == "leaf"){
			var child_schema_path = parent_id + '/' + tree["name"];
			var child_id = next_id();
			addleaf(parent_id, child_id, child_schema_path, tree["name"], tree["description"], 'string', '');
		}
	}
}

function addcontainer(parent_id, id, schemapath, schemaname, description, options){
	var panel = $('<div>')
	var panelheading = $('<div>')
	var panelbody = $('<div>')
	var container = $('<div>');

	panel.addClass('panel');
	panel.addClass('panel-default');

	panelheading.addClass('panel-heading');
	panelheading.html(description);

	panelbody.addClass('panel-body');

	container.attr('id',id);
	container.addClass('schemanode');
	container.attr('data-schemanodetype','container');
	container.attr('data-schemapath',schemapath);
	container.attr('data-schemaname',schemaname);

	$('#'+parent_id).append(panel);
	panel.append(panelheading);
	panel.append(panelbody);
	panelbody.append(container);
}

function addlist(parent_id, id, schemapath, schemaname, description, options){
	var panel = $('<div>')
	var panelheading = $('<div>')
	var panelbody = $('<div>')
	var list = $('<div>');
	var button = $('<button>');
	var panelfooter = $('<div>')

	panel.addClass('panel');
	panel.addClass('panel-default');

	panelheading.addClass('panel-heading');
	panelheading.html(description);

	panelbody.addClass('panel-body');

	list.attr('id',id);
	list.addClass('schemanode');
	list.attr('data-schemanodetype','list');
	list.attr('data-schemapath',schemapath);
	list.attr('data-schemaname',schemaname);

	panelfooter.addClass('panel-footer');

	button.addClass('btn');
	button.addClass('btn-success');
	button.addClass('button-ok');
	button.attr('type','button');
	button.on('click',function(){
		var child_id = next_id();
		addlistelement(id,child_id,'');
		make_form(list_schema_tree[id],child_id);
	});
	button.html('Add');

	$('#'+parent_id).append(panel);
	panel.append(panelheading);
	panel.append(panelbody);
	panelbody.append(list);
	panel.append(panelfooter);
	panelfooter.append(button);
}

function addlistelement(parent_id, id, options){
	var panel = $('<div>')
	var panelbody = $('<div>')
	var listelement = $('<div>');
	var button = $('<button>');
	var panelfooter = $('<div>')

	panel.addClass('panel');
	panel.addClass('panel-default');

	panelbody.addClass('panel-body');

	listelement.attr('id',id);
	listelement.addClass('schemanode');
	listelement.attr('data-schemanodetype','listelement');

	panelfooter.addClass('panel-footer');

	button.addClass('btn');
	button.addClass('btn-success');
	button.addClass('button-ok');
	button.attr('type','button');
	button.on('click',function(){
		$('#'+id).parent().parent().fadeOut('slow', function(){
			$(this).remove();
		});
	});
	button.html('Del');

	$('#'+parent_id).append(panel);
	panel.append(panelbody);
	panelbody.append(listelement);
	panel.append(panelfooter);
	panelfooter.append(button);
}

function addleaflist(parent_id, id, schemapath, schemaname, description, options){
	var list = $('<div>');
	var h4 = $('<h4>');
	var div = $('<div>');
	var table = $('<table>');
	var thead = $('<thead>');
	var theadtr = $('<tr>');
	var theadth0 = $('<th>');
	var theadth1 = $('<th>');
	var tbody = $('<thead>');
	var tbodytr = $('<tr>');
	var tbodytd0 = $('<td>');
	var tbodytd1 = $('<td>');
	list.attr('id','node4');
	list.addClass('schemanode');
	list.addClass('form-group');
	list.attr('data-schemanodetype','list');
	list.attr('data-schemapath','/container1/list');
	list.attr('data-schemaname','list');
	h4.html('List list');
	list.append(h4);
	container1.append(list);

	table.addClass('table');
	table.addClass('table-striped');
	table.addClass('table-hover');
	theadth0.html('col0');
	theadth1.html('col1');
	tbodytd0.html('body0');
	tbodytd1.html('body1');
	table.append(thead);
	thead.append(theadtr);
	theadtr.append(theadth0);
	theadtr.append(theadth1);
	table.append(tbody);
	tbody.append(tbodytr);
	tbodytr.append(tbodytd0);
	tbodytr.append(tbodytd1);
	div.append(table);
	list.append(div);
}

function addleaf(parent_id, id, schemapath, schemaname, description, datatype, options){
	var panel = $('<div>');
	var panelbody = $('<div>');
	var leaf = $('<div>');
	var form = $('<form>')
	var formgroup = $('<div>')
	var label = $('<label>');
	var input;

	var id_form = id + 'form';

	leaf.attr('id',id);
	leaf.addClass('schemanode');
	leaf.attr('data-schemanodetype','leaf');
	leaf.attr('data-schemapath',schemapath);
	leaf.attr('data-schemaname',schemaname);

	formgroup.addClass('form-group');

	label.attr('for', id_form);
	label.html(description);

	if(datatype == "string"){
		input = $('<input>');
		input.attr('id',id_form);
		input.addClass('form-control');
		input.attr('type', 'text');
	}else if(datatype == "enumration"){
		input = $('<select>');
		input.attr('id',id_form);
		input.addClass('form-control');
		var option0 = $('<option>');
		var option1 = $('<option>');
		var option2 = $('<option>');
		option1.html('1');
		option2.html('2');
		input.append(option0);
		input.append(option1);
		input.append(option2);
	}else{
	}

	$('#'+parent_id).append(panel);
	panel.append(panelbody);
	panelbody.append(leaf);
	leaf.append(form);
	form.append(formgroup);
	formgroup.append(label);
	formgroup.append(input);
}

function set_config(trees, id){
	console.log('set_config start');
	Object.keys(trees).forEach(function(key){
		console.log(key);
		if(key == 'config'){
			console.log('in config');
			set_config(trees[key], id);
		}else{
			console.log('in else');
			$('#'+id + ">>>" + ".schemanode").each(function(){
				if($(this).data('schemaname') == key){
					var schemanodetype = $(this).data('schemanodetype');
					if(schemanodetype == 'container'){
						console.log('container');
						set_config(trees[key], this.id);
					}else if(schemanodetype == 'list'){
						console.log('list');
						for(var i=0; i<trees[key].length; i++){
							var child_id = next_id();
							addlistelement(this.id, child_id, '');
							make_form(list_schema_tree[this.id],child_id);
							set_config(trees[key][i], child_id);
						}
					}else if(schemanodetype == 'leaf'){
						console.log('leaf');
						$(this).find("input").val(trees[key]);
					}
				}
			});
		}
	});
}

function get_config(id){
	var data = {};
	if($('#'+id).data('schemanodetype') == "leaf"){
		var value = $('#'+id).find("input").val();
		data[$('#'+id).data('schemaname')] = value;
	}else if($('#'+id).data('schemanodetype') == "container"){
		var tmp = {};
		$('#'+id + ">>>" + ".schemanode").each(function(){
			$.each(get_config(this.id),function(key,value){
				tmp[key] = value;
			});
		});
		data[$('#'+id).data('schemaname')] = tmp;
	}else if($('#'+id).data('schemanodetype') == "list"){
		var tmp = [];
		$('#'+id + ">>>" + ".schemanode").each(function(){
			tmp.push(get_config(this.id));
		});
		data[$('#'+id).data('schemaname')] = tmp;
	}else{
		var tmp = {};
		$('#'+id + ">>>" + ".schemanode").each(function(){
			$.each(get_config(this.id),function(key,value){
				tmp[key] = value;
			});
		});
		if(id == 'root'){
			data['config'] = tmp;
		}else{
			data = tmp;
		}
	}
	return data;
}

$(".button-ok").on('click',function(){
	if(window.confirm("Are you sure?")){
		$('#myModal').modal();
		var json = JSON.stringify(get_config('root'), " ", 2);
		console.log(json);
		//alert(json);
		$.ajax({
			type: 'POST',
			url: "api/data",
			dataType: 'json',
			data: json,
			timeout: 10000
		}).done(function(data, status, xhr){
			console.log(data);
			alert('success');
			location.reload();
		}).fail(function(xhr, status, error){
			alert('failed to send config');
			$('#myModal').modal('hide');
		}).always(function(){
		});
	}
});
