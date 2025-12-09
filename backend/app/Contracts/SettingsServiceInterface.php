<?php

namespace App\Contracts;

interface SettingsServiceInterface
{
    /**
     * Get all settings for a specific group.
     *
     * @param string $group
     * @return array
     */
    public function getGroup(string $group): array;

    /**
     * Update settings for a specific group.
     *
     * @param string $group
     * @param array $data
     * @return array
     */
    public function updateGroup(string $group, array $data): array;

    /**
     * Get the data type for a specific key in a group.
     *
     * @param string $group
     * @param string $key
     * @return string
     */
    public function getTypeForKey(string $group, string $key): string;

    /**
     * Serialize a value for storage based on its type.
     *
     * @param mixed $value
     * @param string $type
     * @return string
     */
    public function serializeValue($value, string $type): string;

    /**
     * Cast a stored value to its proper type.
     *
     * @param string|null $value
     * @param string $type
     * @return mixed
     */
    public function castValue(?string $value, string $type);
}