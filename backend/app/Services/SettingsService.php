<?php

namespace App\Services;

use App\Contracts\SettingsServiceInterface;
use App\Models\Setting;
use Illuminate\Support\Collection;

class SettingsService implements SettingsServiceInterface
{
    /**
     * Get all settings for a specific group.
     *
     * @param string $group
     * @return array
     */
    public function getGroup(string $group): array
    {
        $settings = Setting::where('group', $group)->get();

        $result = [];
        foreach ($settings as $setting) {
            $result[$setting->key] = $this->castValue($setting->value, $setting->type);
        }

        return $result;
    }

    /**
     * Update settings for a specific group.
     *
     * @param string $group
     * @param array $data
     * @return array
     */
    public function updateGroup(string $group, array $data): array
    {
        foreach ($data as $key => $value) {
            $type = $this->getTypeForKey($group, $key);
            $storedValue = $this->serializeValue($value, $type);

            Setting::updateOrCreate(
                ['group' => $group, 'key' => $key],
                [
                    'value' => $storedValue,
                    'type' => $type,
                    'autoload' => true,
                ]
            );
        }

        return $this->getGroup($group);
    }

    /**
     * Get the data type for a specific key in a group.
     *
     * @param string $group
     * @param string $key
     * @return string
     */
    public function getTypeForKey(string $group, string $key): string
    {
        $config = config('settings.groups', []);

        return $config[$group][$key] ?? 'string';
    }

    /**
     * Serialize a value for storage based on its type.
     *
     * @param mixed $value
     * @param string $type
     * @return string
     */
    public function serializeValue($value, string $type): string
    {
        return match ($type) {
            'boolean' => $value ? '1' : '0',
            'json' => json_encode($value),
            default => (string) $value,
        };
    }

    /**
     * Cast a stored value to its proper type.
     *
     * @param string|null $value
     * @param string $type
     * @return mixed
     */
    public function castValue(?string $value, string $type)
    {
        if ($value === null) {
            return match ($type) {
                'boolean' => false,
                'integer' => 0,
                'float' => 0.0,
                'json' => [],
                default => null,
            };
        }

        return match ($type) {
            'boolean' => (bool) $value,
            'integer' => (int) $value,
            'float' => (float) $value,
            'json' => json_decode($value, true),
            default => $value,
        };
    }
}