package com.webthietbibep.services;

import com.webthietbibep.dao.CategoryDAO;
import com.webthietbibep.model.Category;

import java.util.List;

public class CategoryService {
    CategoryDAO cDAO = new CategoryDAO();
    public List<Category> getAll() {
        return cDAO.getAll();
    }
    public boolean checkExist(int id){
        return cDAO.checkExist(id);
    }
    public List<Category> getTopCategories() {
        return cDAO.getTopCategories();
    }
    public Category getCategoryById(int id){
        return cDAO.getCategoryById(id);
    }
}
