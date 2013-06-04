/**
 * 
 */
package com.cypress.forum.dao;

/**
 * The Class Entity.
 * 
 * <pre>
 * Revision History:
 * Jun 3, 2013	neys	Initial implementation
 * </pre>
 * 
 * @author Neyas Anand (neys)
 */
public abstract class Entity {

    /** The id. */
    private String id;

    /**
     * Gets the id.
     * 
     * @return the id
     */
    public String getId() {
        return id;
    }

    /**
     * Sets the id.
     * 
     * @param id
     *            the new id
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * Instantiates a new entity.
     */
    public Entity() {
    }
}
