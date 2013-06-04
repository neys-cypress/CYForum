/**
 * 
 */
package com.cypress.forum.dao;

import java.io.Serializable;
import java.util.List;

/**
 * The Interface IRepo.
 * 
 * <pre>
 * Revision History:
 * Jun 3, 2013	neys	Initial implementation
 * </pre>
 * 
 * @param <T>
 *            the generic type
 * @param <ID>
 *            the generic type
 * @author Neyas Anand (neys)
 */
public interface IRepo<T extends Entity, ID extends Serializable> {

    // CRUD Operations
    /**
     * Creates the.
     * 
     * @param obj
     *            the obj
     * @return true, if successful
     */
    ID create(T obj);

    /**
     * Read.
     * 
     * @param d
     *            the d
     * @return the t
     */
    T read(ID d);

    /**
     * Update.
     * 
     * @param obj
     *            the obj
     * @return true, if successful
     */
    boolean update(T obj);

    /**
     * Delete.
     * 
     * @param obj
     *            the obj
     * @return true, if successful
     */
    boolean delete(T obj);

    // Criteria queries
    
    /**
     * Read all.
     *
     * @return the list
     */
    List<T> readAll();
    
    /**
     * Count.
     *
     * @return the int
     */
    int count();

}
