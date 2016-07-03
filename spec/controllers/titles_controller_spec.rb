# -*- coding: utf-8 -*-
require 'rails_helper'

describe TitlesController do
  let(:user) { create :user }
  before { sign_in user }

  describe 'GET index' do
    it 'assigns ids of watching title as @watching_ids' do
      titles = [
        create(:title, kana: 'あああ'),
        create(:title, kana: 'いいい')
      ]
      others = FactoryGirl.create :title, kana: 'かかか'
      create :watching, user: user, title: titles.first
      create :watching, user: user, title: others
      get :index, params: { initial: 'あ' }, format: 'json'
      expect(assigns(:watching_ids)).to eq [titles.first.id]
    end

    context 'current' do
      it 'assigns unfinished titles as @titles' do
        titles = create_list :title, 3, finished_at: nil
        create_list :title, 3, finished_at: Time.zone.now.beginning_of_year
        get :index, format: 'json'
        expect(assigns(:titles)).to eq titles.sort_by(&:kana)
      end
    end

    context 'all' do
      it 'assigns all titles as @titles' do
        titles = create_list :title, 9, finished_at: Time.zone.now.beginning_of_year
        get :index, params: { initial: 'all' }, format: 'json'
        expect(assigns(:titles)).to eq titles.sort_by(&:kana)
      end
    end

    context 'with initial' do
      it 'assigns matched titles as @titles' do
        titles = [
          create(:title, kana: 'あああ'),
          create(:title, kana: 'いいい')
        ]
        create(:title, kana: 'かかか')
        get :index, params: { initial: 'あ' }, format: 'json'
        expect(assigns(:titles)).to eq titles
      end
    end
  end

  describe 'PUT update' do
    it 'create watching' do
      title = create :title
      put :update, params: { id: title.to_param }
      expect(Watching.where(user_id: user.id, title_id: title.id)).to be_exists
    end
  end

  describe 'DELETE destroy' do
    it 'delete user_channel' do
      watching = create :watching, user: user
      delete :destroy, params: { id: watching.title.to_param }
      expect(Watching.where(user_id: user.id, title_id: watching.title_id)).not_to be_exists
    end
  end
end
