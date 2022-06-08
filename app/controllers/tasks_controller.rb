class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    @task = Task.new
    @done_tasks = Task.where(completed: true)
    @tasks = Task.where(completed: false)
  end

  def show
  end

  def active
    @task = Task.find(params[:id])
    @task.update(completed: !@task.completed)
    respond_to do |format|
      format.turbo_stream { render partial: 'tasks/active', locals: { task: @task } }
      @task.broadcast_render_later_to 'tasks', partial: 'tasks/active', locals: { task: @task }
    end
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_url, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
        @task.broadcast_render_later_to 'tasks', partial: 'tasks/active', locals: { task: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :completed)
    end
end
