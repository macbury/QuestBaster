class QuestTemplatesController < ApplicationController
  
  def suggest_game_object
    begin
      @object = GameObject.find(params[:entry])
    rescue ActiveRecord::RecordNotFound
      @object = GameObject.new(:entry => params[:entry], :name => '[NONE]')
    end
    
    render :json => { :name => @object.name, :entry => @object.entry }
  end
  
  def suggest_monster
    @monsters = Monster.all(:conditions => ['name LIKE ? OR entry = ?', "%#{params[:q]}%", params[:q].to_i], :limit => 10)
    
    respond_to do |format|
      format.html { render :text => @monsters.map(&:name).join("\n") }
      format.json { render :json => { :name => @monsters[0].name, :entry => @monsters[0].entry } }
    end
    
  end
  
  def sugest_faction
    @factions = []
    faction_value = params[:q]
    unless faction_value.nil?
      Factions.each do |faction_id, faction_name|
        if faction_name =~ /^#{faction_value}/i || faction_id == faction_value.to_i
          @factions << faction_name
        end
      end
    end
    render :text => @factions.join("\n")
  end
  
  def suggest_item
    @items = ItemTemplate.all(:conditions => ['name LIKE ? OR entry = ?', "%#{params[:q]}%", params[:q].to_i], :limit => 10).map(&:name)
    
    render :text => @items.join("\n")
  end
  
  def sugest_zone_or_sort
    @results = []
    
    zone_value = params[:q]
    
    unless zone_value.nil?
      Zones.each do |area_id, area_name|
        if area_name =~ /^#{zone_value}/i || area_id == zone_value.to_i
          @results << area_name
        end
      end

      Quest_Sort.each do |sort_id, sort_name|
        if sort_name =~ /^#{zone_value}/i || sort_id == zone_value.to_i
          @results << sort_name
        end
      end
    end

    render :text => @results.join("\n")
  end
  
  # GET /quest_templates
  # GET /quest_templates.xml
  
  def index
    @p = params[:quest] || {}
    
    @sort_by = params[:sort_by] || "Title"
    @sort_type = params[:sort_type] || "asc"
    order = ["Title","QuestLevel","MinLevel"].find(lambda {"Title"}) {|sort| sort == @sort_by}
    order += (@sort_type == "asc")? " ASC" : " DESC"
    
    conditions = {}
    
    unless @p.nil? || @p.blank?
      conditions[:Title.like] = "%#{@p[:title]}%" unless @p[:title].nil? || @p[:title].blank?

      unless @p[:level].nil? || @p[:level].blank?
        conditions[:QuestLevel.gte] = @p[:level].to_i
      end
      
      unless @p[:type].nil? || @p[:type].blank?
        conditions[:Type] = @p[:type].to_i 
        @p[:type] = @p[:type].to_i
      else
        @p[:type] = nil
      end
      
      unless @p[:race].nil? || @p[:race].blank?
        conditions[:RequiredRaces] = @p[:race].to_i 
        @p[:race] = @p[:race].to_i
      else
        @p[:race] = 0
      end
    end
    
    @quest_templates = QuestTemplate.paginate :per_page => 20, :page => params[:page], :conditions => conditions, :order => order
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quest_templates }
    end
  end

  # GET /quest_templates/1
  # GET /quest_templates/1.xml
  def show
    @quest = QuestTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.yaml do
        attributes = @quest.attributes
        attributes.merge!({
          'quest_giver_id' => @quest.quest_giver_id,
          'quest_giver_type' => @quest.quest_giver_type,
          'quest_involver_type' => @quest.quest_involver_type,
          'quest_involver_id' => @quest.quest_involver_id
        })
        send_data attributes.to_yaml, :filename => sexy_unix_name(@quest)
      end

    end
  end

  # GET /quest_templates/new
  # GET /quest_templates/new.xml
  def new
    @quest_template = QuestTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @quest_template }
    end
  end

  # GET /quest_templates/1/edit
  def edit
    @quest_template = QuestTemplate.find(params[:id])
    render :action => "new"
  end

  # POST /quest_templates
  # POST /quest_templates.xml
  def create
    @quest_template = QuestTemplate.new(params[:quest_template])

    respond_to do |format|
      if @quest_template.save
        flash[:notice] = 'QuestTemplate was successfully created.'
        format.html { redirect_to(@quest_template) }
        format.xml  { render :xml => @quest_template, :status => :created, :location => @quest_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @quest_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /quest_templates/1
  # PUT /quest_templates/1.xml
  def update
    @quest_template = QuestTemplate.find(params[:id])

    respond_to do |format|
      if @quest_template.update_attributes(params[:quest_template])
        flash[:notice] = 'QuestTemplate was successfully updated.'
        format.html { redirect_to(@quest_template) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quest_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /quest_templates/1
  # DELETE /quest_templates/1.xml
  def destroy
    @quest_template = QuestTemplate.find(params[:id])
    @quest_template.destroy

    respond_to do |format|
      format.html { redirect_to(quest_templates_url) }
      format.xml  { head :ok }
    end
  end
  
  protected 
    
    def sexy_unix_name(quest)
      name = ''
      name += "#{quest.entry}_"
      title = @quest.title.strip
      
      title.gsub!('!','')
      title.gsub!('?','')
      title.gsub!('.','')
      title.gsub!(',','')
      title.gsub!(' ','_')
      title.gsub!('"','')
      title.gsub!('\'','')
      name += "#{title}.quest"
      
      return name
    end
end
