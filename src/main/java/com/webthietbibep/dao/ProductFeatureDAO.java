package com.webthietbibep.dao;

import com.webthietbibep.model.ProductFeature;

import java.util.List;

public class ProductFeatureDAO extends BaseDao {

    public List<ProductFeature> getByProductId(int productId) {
        return get().withHandle(handle ->
                handle.createQuery("""
                    SELECT *
                    FROM product_features
                    WHERE product_id = :pid
                """)
                        .bind("pid", productId)
                        .mapToBean(ProductFeature.class)
                        .list()
        );
    }
}
