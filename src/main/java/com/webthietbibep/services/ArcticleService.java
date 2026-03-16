package com.webthietbibep.services;

import com.webthietbibep.dao.ArticleDao;
import com.webthietbibep.model.Article;

import java.util.List;

public class    ArcticleService {
    ArticleDao adao = new ArticleDao();


    public List<Article>  getListHotArticle() {
        return adao.getListHotArticle();
    }
    public List<Article> getFilterArticle(String f){
        return adao.getFilterArticle(f);
    }
    public List<Article> getNewArticle(){
        return adao.getNewArticle();
    }
    public List<Article> getFilterArticleAdmin (String filter,String search,int page, int pageSize){
        return adao.getFilterArticleAdmin(filter,search,page,pageSize);
    }
    public void addArticle(Article a){
        adao.addArticle(a);
    }
    public boolean deleteArticle(int id){
        return adao.deleteArticle(id);
    }
    public  Article getArticleById(int id){
        return adao.getArticleById(id);
    }
    public boolean updateArticle(Article a){
        return adao.updateArticle(a);
    }
    public int getTotalArticle(String filter, String search){
        return adao.getTotalArticles(filter,search);
    }
    public List<Article> getArticleByCategory(int id,String f){
        return adao.ArticleByCategory(id,f);
    }
}
