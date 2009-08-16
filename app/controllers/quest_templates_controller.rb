class QuestTemplatesController < ApplicationController
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
      format.xml  { render :xml => @quest_template }
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
end
