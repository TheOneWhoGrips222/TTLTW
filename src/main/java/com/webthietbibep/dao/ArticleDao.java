package com.webthietbibep.dao;

import com.webthietbibep.model.Article;

import java.util.List;

public class ArticleDao extends  BaseDao{



    public List<Article> getListHotArticle(){
        return  get().withHandle(h ->{
            return h.createQuery("SELECT * FROM articles where is_active = 1  order by likecount DESC LIMIT 3;").mapToBean(Article.class).list();
        });
    }
    public List<Article> getNewArticle(){
        return  get().withHandle(h ->{
            return h.createQuery("SELECT * FROM articles where is_active = 1 order by create_date DESC LIMIT 3;").mapToBean(Article.class).list();
        });
    }
    public List<Article> getFilterArticle(String f){
        return  get().withHandle(h ->{

            String query = "SELECT * FROM articles WHERE is_active = 1 ";
            if("new".equals(f)){query += " " + "ORDER BY create_date DESC ";}
            else if("population".equals(f)) {query += " " + "ORDER BY likecount DESC";}
            else {query += " " + "ORDER BY title ASC";}

            return h.createQuery(query).mapToBean(Article.class).list();
        });
    }

    public List<Article> getFilterArticleAdmin(String filter,String search,int page, int pageSize){
        return  get().withHandle(h ->{

            String query = "SELECT * FROM articles WHERE 1=1 AND ";
            if("new".equals(filter)){query += " " + " title like '%" +search+ "%' " +"ORDER BY create_date DESC ";}
            else if("old".equals(filter)) {query += " " + " title like '%" +search+ "%' " +"ORDER BY create_date ASC";}
            else if(filter.equals("type")){query += " " + "tip like '%" +search+ "%' " +"ORDER BY create_date DESC ";}
            else if(filter.equals("published")){query += " " + "is_active = 1 ORDER BY create_date DESC ";}
            else if(filter.equals("raw")){query += " " + "is_active = 0 ORDER BY create_date DESC ";}
            else {query += " " + "title like '%" +search+ "%' " + "ORDER BY title ASC";}
            query += " LIMIT :limit OFFSET :offset ";
            int offset = (page - 1) * pageSize;
            return h.createQuery(query).bind("limit", pageSize).bind("offset", offset).mapToBean(Article.class).list();
        });
    }

    public int getTotalArticles(String filter, String search) {
        return get().withHandle(h -> {
            StringBuilder query = new StringBuilder("SELECT COUNT(*) FROM articles WHERE 1=1 ");

            if ("published".equals(filter)) query.append(" AND is_active = 1 ");
            else if ("raw".equals(filter)) query.append(" AND is_active = 0 ");
            else if ("type".equals(filter)) query.append(" AND tip LIKE :search ");
            else query.append(" AND title LIKE :search ");

            return h.createQuery(query.toString())
                    .bind("search", "%" + search + "%")
                    .mapTo(Integer.class)
                    .one();
        });
    }

    public void addArticle(Article article){
        get().useHandle(h->{
            String sql = "INSERT INTO articles (title, tip, content, body, category_id, image, author, is_active, create_date, likecount) "
                    + "VALUES (:title, :tip, :content, :body, :category_id, :image, :author, :is_active,:create_date, :likecount)";
            h.createUpdate(sql).bindBean(article).execute();

        });
    }

    public boolean deleteArticle(int id){
        String sql = "DELETE FROM articles WHERE id = :id";
      return  get().withHandle(h->{
         return   h.createUpdate(sql).bind("id",id).execute() > 0;
        });
    }

    public Article getArticleById(int id){
        String sql = "SELECT * FROM articles WHERE id = :id";
        return get().withHandle(h->{
            return  h.createQuery(sql).bind("id",id).mapToBean(Article.class).stream().findFirst().orElse(null);
        });
    }

    public boolean updateArticle(Article article){
        String sql = "UPDATE articles Set title = :title , author = :author, tip = :tip,category_id = :category_id,body = :body , image = :image , is_active = :is_active  WHERE id = :id ";
        return get().withHandle(h->{
            return  h.createUpdate(sql).bindBean(article)
                    .execute() > 0;
        });
    }

    public List<Article> ArticleByCategory(int id,String f){
        return  get().withHandle(h ->{

            String query = "SELECT * FROM articles WHERE is_active = 1 AND category_id = :id ";
            if("new".equals(f)){query += " " + "ORDER BY create_date DESC ";}
            else if("population".equals(f)) {query += " " + "ORDER BY likecount DESC";}
            else {query += " " + "ORDER BY title ASC";}

            return h.createQuery(query).bind("id",id).mapToBean(Article.class).list();
        });

}
}
